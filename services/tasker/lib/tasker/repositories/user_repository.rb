class UserRepository < Hanami::Repository
  associations do
    has_many :auth_identities
    has_many :tasks
  end

  def find_by_public_id(public_id)
    root.where(public_id: public_id).one
  end

  def find_by_id(id)
    root.where(id: id).one
  end

  def find_or_create_by_public_id(public_id, params)
    user = root.find_by_public_id(public_id)
    return user if user.present?

    root.create(params)
  end

  def find_by_auth_identity(provider, auth_identity)
    root
      .join(auth_identities)
      .where(auth_identities[:provider] => provider)
      .where(auth_identities[:login] => auth_identity[:login])
      .map_to(User).one
  end

  def create_with_identity(provider, user, auth_identity)
    assoc(:auth_identities, user).add(**auth_identity, provider: provider)
  end

  def random_user
    users.read('SELECT * FROM users ORDER BY random() LIMIT 1;').one
  end
end
