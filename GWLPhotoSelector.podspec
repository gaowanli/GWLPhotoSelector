Pod::Spec.new do |s|
  s.name         = "GWLPhotoSelector"
  s.version      = "1.0.1"
  s.summary      = "相册照片多张选择控件"
  s.homepage     = "https://github.com/gaowanli/GWLPhotoSelector"
  s.license      = "MIT"
  s.author       = { "Wanli Gao" => "im_gwl@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/gaowanli/GWLPhotoSelector.git", :tag => s.version }
  s.source_files = "GWLPhotoSelector/*"
  s.requires_arc = true
end
