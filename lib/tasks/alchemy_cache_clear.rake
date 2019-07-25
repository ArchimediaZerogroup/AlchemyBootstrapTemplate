namespace :alchemy do
    namespace :cache do
      desc "Complete Clear the cache of all pages"
      task full_clear: [:environment] do
        Alchemy::Language.published.each do |l|
          l.pages.flushables.update_all(published_at: Time.current)
          l.pages.flushable_layoutpages.update_all(published_at: Time.current)
        end
      end
    end
end