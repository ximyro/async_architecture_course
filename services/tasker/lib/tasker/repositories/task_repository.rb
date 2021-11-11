class TaskRepository < Hanami::Repository
  associations do
    belongs_to :user
  end

  def find_user_tasks(user)
    aggregate(:user).where(user_id: user.id)
  end

  def all_opened_tasks
    root.where("status = 'created'")
  end

  def find_with_users
    aggregate(:user)
  end
end
