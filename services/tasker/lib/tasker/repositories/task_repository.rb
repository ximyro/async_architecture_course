class TaskRepository < Hanami::Repository
  associations do
    belongs_to :user
  end

  def all_with_user(user)
    aggregate(:user).where(user_id: user.id)
  end

  def all_opened
    root.where("status = 'created'")
  end

  def all
    aggregate(:user)
  end
end
