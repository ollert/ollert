class BoardAnalyzer
  def self.analyze(raw)
    return {} if raw.nil? || raw.empty?

    trello_boards = {}
    JSON.parse(raw).each do |board|
      organization = board["organization"].nil? ? "My Boards" : board["organization"]["displayName"]
      trello_boards[organization] ||= []
      trello_boards[organization] << board
    end

    trello_boards
  end
end