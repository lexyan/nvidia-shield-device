include vendor/nvidia/build/detectversion.mk
PRODUCT_MAKEFILES := \
  $(LOCAL_DIR)/loki_e_lte.mk \
  $(LOCAL_DIR)/loki_e_wifi.mk \
  $(LOCAL_DIR)/loki_e_tab_os.mk \
  $(LOCAL_DIR)/loki_e_base.mk \
  $(LOCAL_DIR)/foster_e_hdd.mk \
  $(LOCAL_DIR)/foster_e.mk \
  $(LOCAL_DIR)/darcy.mk \
  $(LOCAL_DIR)/mdarcy.mk
