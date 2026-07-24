source 'https://rubygems.org'

gem 'jekyll'

group :jekyll_plugins do
    gem 'jekyll-email-protect'    # obfuscates the email address in the page source
    gem 'jekyll-feed'             # /feed.xml
    gem 'jekyll-imagemagick'      # responsive .webp versions of assets/img
    gem 'jekyll-link-attributes'  # adds target/rel to external links
    gem 'jekyll-minifier'         # minifies HTML/CSS/JS on production builds
    gem 'jekyll-sitemap'          # /sitemap.xml
    gem 'jemoji'
end

# Required by _plugins/download-3rd-party.rb, which expands {{version}} in the
# third_party_libraries URLs in _config.yml.
group :other_plugins do
    gem 'css_parser'
    gem 'nokogiri'
end
