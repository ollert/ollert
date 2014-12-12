class BoardAnalyzer
  def self.analyze(data)
    return {} if data.nil? || data.empty?

    trello_boards = {}
    data.each do |board|
      organization = board["organization"].nil? ? "My Boards" : board["organization"]["displayName"]
      trello_boards[organization] ||= []
      trello_boards[organization] << board
    end

    trello_boards
  end
end