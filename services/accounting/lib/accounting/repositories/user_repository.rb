class UserRepository < Hanami::Repository
  associations do
    has_many :auth_identities
    has_many :tasks
  end

  def find_by_public_id(public_id)
    users.where(public_id: public_id).one
  end

  def find_by_id(id)
    users.where(id: id).one
  end

  def find_or_create_by_public_id(public_id, params)
    user = find_by_public_id(public_id)
    return user if user.present?

    create(params)
  end

  def accure_balance(user_id, amount)
    root.update("balance = balance + #{amount} WHERE id = #{user_id}")
  end

  def withdraw_balance(user_id, amount)
    root.update("balance = balance - #{amount} WHERE id = #{user_id}")
  end

  def find_by_auth_identity(provider, auth_identity)
    users
      .join(auth_identities)
      .where(auth_identities[:provider] => provider)
      .where(auth_identities[:login] => auth_identity[:login])
      .map_to(User).one
  end

  def create_with_identity(provider, user, auth_identity)
    assoc(:auth_identities, user).add(**auth_identity, provider: provider)
  end

  def set_zero_balance(user_id)
    update(user_id, balance: 0)
  end

  def create_or_update_by_public_id(public_id, data)
    user = find_by_public_id(public_id)
    if user
      return update(
        user.id,
        role: data['role'],
        email: data['email'],
        full_name: data['full_name']
      )
    end
    create(
      role: data['role'],
      email: data['email'],
      full_name: data['full_name'],
      public_id: data['public_id']
    )
  end
end
