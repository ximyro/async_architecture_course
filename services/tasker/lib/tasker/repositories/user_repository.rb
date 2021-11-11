class UserRepository < Hanami::Repository
  associations do
    has_many :auth_identities
  end

  def find_by_public_id(public_id)
    root.where(public_id: public_id).first
  end

  def find_by_auth_identity(provider, auth_identity)
    root
      .join(auth_identities)
      .where(auth_identities[:provider] => provider)
      .where(auth_identities[:login] => auth_identity[:login])
      .map_to(User).one
  end

  def create_with_identity(provider, user, auth_identity)
    assoc(:auth_identities).create(
      **user,
      auth_identities: [{ **auth_identity, provider: provider }]
    )
  end
end
