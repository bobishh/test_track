json.name variant_detail.display_name
json.description variant_detail.description

if variant_detail.screenshot.present?
  json.screenshot_url variant_detail.screenshot.expiring_url(300)
end
