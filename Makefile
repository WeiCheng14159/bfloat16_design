ROOT_DIR           =$(PWD)
BUILD              =build
BUILD_DIR          =$(ROOT_DIR)/$(BUILD)
SRC_DIR            =$(ROOT_DIR)/src
SIM_DIR            =$(ROOT_DIR)/sim
SYN_DIR            =$(ROOT_DIR)/syn
SCRIPT_DIR         =$(ROOT_DIR)/script
REPORT_DIR         =$(ROOT_DIR)/report
NC_DIR             =$(ROOT_DIR)/conf

TB_TOP             =fpu_tb
TOP                =fpu

SRC=$(shell find $(SRC_DIR) -name "*.v" -o -name "*.sv")
TB_SRC=$(shell ls $(SIM_DIR)/*.txt)

# icc, u18, t18
PROC               =t65
ifeq ($(PROC), icc)
	CBDK_DIR         =/usr/cad/lib/CBDK_IC_Contest_v2.1/Verilog
	CORE_CELL        =tsmc13_neg.v
	IO_CELL          =
else ifeq ($(PROC), u18)
	CBDK_DIR         =/usr/cad/CBDK/CBDK018_UMC_Faraday_v1.0/CIC/Verilog
	CORE_CELL        =fsa0m_a_generic_core_21.lib.src
	IO_CELL          =fsa0m_a_t33_generic_io_21.lib.src
else ifeq ($(PROC), t18)
	CBDK_DIR         =/usr/cad/CBDK/CBDK_TSMC018_Arm_f1.0/CIC/Verilog
	CORE_CELL        =tsmc18_neg.v
	IO_CELL          =
else ifeq ($(PROC), t65)
	CBDK_DIR         =/opt/PDK/TSMC65/ARM/cln65gplus/sc12_base_rvt/r3p0-00eac0/verilog
	CORE_CELL        =sc12_cln65gplus_base_rvt_neg.v
	IO_CELL          =
else
	CBDK_DIR         =
	CORE_CELL        =
	IO_CELL          =
endif

APR_DIR            =$(ROOT_DIR)/icc/$(PROC)/run

.PHONY: default init check rtl nw sv syn syn_init icc_init autosyn pre pre_sv clean

# Show available all command
default:
	@echo "clean       => Clean previous build"
	@echo "rtl         => Run RTL simulation"
	@echo "nw          => Run nWave"
	@echo "synthesize  => Run synthesize in interactive mode"
	@echo "syn         => Run gate-level simulation"
	@echo "check       => Run superlint"

$(BUILD):
	mkdir -p $(BUILD)

# Create folders
init: clean
	mkdir -p $(BUILD_DIR) $(SYN_DIR) $(REPORT_DIR)

# Syn directory init
syn_init:
	mkdir -p $(SYN_DIR);

icc_init:
	mkdir -p $(APR_DIR); \
	mkdir -p $(APR_DIR)/../design_data; \
	mkdir -p $(APR_DIR)/../verify/drc; \
	mkdir -p $(APR_DIR)/../verify/lvs;

cp_tb_src: gen_hex
	cd $(BUILD_DIR); \
	cp $(TB_SRC) .;

# Add your script here
gen_hex:
	cd py;

# Check HDL syntax
check:
	jg -superlint $(SCRIPT_DIR)/superlint.tcl &

# Format SystemVerilog/Verilog files in $(SRC_DIR)
format:
	find $(SRC_DIR) -name "*.sv" -or -name "*.v" -or -name "*.svh" | xargs verible-verilog-format --inplace

# Run RTL simulation for ADD
rtl0: $(BUILD) cp_tb_src
	cd $(BUILD_DIR); \
	ncverilog $(SIM_DIR)/$(TB_TOP).v $(SRC) \
	+incdir+$(SRC_DIR) \
	+nc64bit \
	+access+r \
	+define+SHM_FILE=\"$(TOP).shm\" \
	+define+ADD

# Run RTL simulation for SUB
rtl1: $(BUILD) cp_tb_src
	cd $(BUILD_DIR); \
	ncverilog $(SIM_DIR)/$(TB_TOP).v $(SRC) \
	+incdir+$(SRC_DIR) \
	+nc64bit \
	+access+r \
	+define+SHM_FILE=\"$(TOP).shm\" \
	+define+SUB

# Run RTL simulation for MUL
rtl2: $(BUILD) cp_tb_src
	cd $(BUILD_DIR); \
	ncverilog $(SIM_DIR)/$(TB_TOP).v $(SRC) \
	+incdir+$(SRC_DIR) \
	+nc64bit \
	+access+r \
	+define+SHM_FILE=\"$(TOP).shm\" \
	+define+MUL

# Run RTL simulation for DIV
rtl3: $(BUILD) cp_tb_src
	cd $(BUILD_DIR); \
	ncverilog $(SIM_DIR)/$(TB_TOP).v $(SRC) \
	+incdir+$(SRC_DIR) \
	+nc64bit \
	+access+r \
	+define+SHM_FILE=\"$(TOP).shm\" \
	+define+DIV

# View waveform using nWave
nw: $(BUILD)
	cd $(BUILD_DIR); \
	nWave -f $(TOP).fsdb -sswr $(NC_DIR)/signal.rc +access+r +nc64bit &

# Run synthesize with Design Compiler
synthesize: $(BUILD) syn_init
	rm -rf $(SYN_DIR)/*; \
	cd $(BUILD_DIR); \
	cp $(SCRIPT_DIR)/${PROC}/synopsys_dc.setup.$(PROC) $(BUILD_DIR)/.synopsys_dc.setup; \
	dc_shell -f $(SCRIPT_DIR)/dc_syn.tcl -x "set proc ${PROC}";

# Run gate-level simulation (nWave)
syn: $(BUILD) cp_tb_src syn_init
	cd $(BUILD_DIR); \
	ncverilog $(SIM_DIR)/$(TB_TOP).v $(SYN_DIR)/$(TOP)_syn.v \
	-v $(CBDK_DIR)/$(CORE_CELL) \
	+nc64bit \
	+access+r \
	+define+FSDB_FILE=\"$(TOP).fsdb\" \
	+define+SDF \
	+define+SDFFILE=\"$(SYN_DIR)/$(TOP)_syn.sdf\"

# Run post-apr simulation (nWave)
pr: $(BUILD) cp_tb_src
	cd $(BUILD_DIR); \
	cp $(APR_DIR)/$(TOP)_pr.sdf $(BUILD_DIR); \
	ncverilog $(SIM_DIR)/$(TB_TOP).v $(APR_DIR)/$(TOP)_pr.v \
	-v $(CBDK_DIR)/$(CORE_CELL) \
	+nc64bit \
	+access+r \
	+define+FSDB_FILE=\"$(TOP).fsdb\" \
	+define+SDF \
	+define+SDFFILE=\"$(APR_DIR)/$(TOP)_pr.sdf\"

# Run ICC APR flow
icc: syn_init icc_init
	cp $(SYN_DIR)/${TOP}_syn.v $(APR_DIR)/../design_data; \
	cp $(SYN_DIR)/${TOP}.sdc $(APR_DIR)/../design_data; \
	cp $(SCRIPT_DIR)/${PROC}/synopsys_dc.setup.$(PROC) $(APR_DIR)/.synopsys_dc.setup; \
	cd $(APR_DIR); \
	icc_shell -gui; \

# Remove all files
clean:
	rm -rf $(BUILD_DIR) $(SYN_DIR) $(APR_DIR) $(REPORT_DIR) *.log
