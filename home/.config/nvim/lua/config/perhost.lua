-- Set some global vars that can be referenced elsewhere
lww_perhost_has_jdtls = false

if vim.uv.os_gethostname() == 'bramball' then
  lww_perhost_has_jdtls = true
end
