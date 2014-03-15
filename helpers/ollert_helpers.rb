
module OllertHelpers
  def get_client(public_key, token)
    Trello::Client.new(
      :developer_public_key => public_key,
      :member_token => token
    )
  end

  def haml_view_model(view, locals)
    default_locals = {logged_in: false}
    locals = default_locals.merge locals
    haml view.to_sym, locals => locals
  end
end
