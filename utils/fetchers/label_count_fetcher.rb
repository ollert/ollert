require 'json'

class LabelCountFetcher
  def self.fetch(client, board_id, show_archived=false)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {
      fields: "labels",
      actions: :createCard,
      limit: 1000
    }
    endpoint = "/boards/#{board_id}/cards/open"
    if show_archived
      endpoint = "/boards/#{board_id}/cards"
      options[:filter] = :all
    end

    cards = []
    before = nil
    loop do
      newCards = JSON.parse(client.get(endpoint, options.merge({before: before})))
      cards.concat newCards
      break unless newCards.count == 1000

      begin
        before = newCards&.first["actions"]&.first["date"]
      rescue Exception => e  
        puts "Issue #54 (still)"
        puts newCards.count
        puts newCards&.first
        
        puts e.message
        puts e.backtrace.inspect
        
        break
      end
    end
    cards
  end
end
