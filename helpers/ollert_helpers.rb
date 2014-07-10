module OllertHelpers
  def haml_view_model(view, user = nil)
    haml view.to_sym, locals: {logged_in: !!user}
  end
end
