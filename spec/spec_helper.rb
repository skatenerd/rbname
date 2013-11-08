def clear_tmp
  FileUtils.rm_rf("tmp/.", secure: true)
end
