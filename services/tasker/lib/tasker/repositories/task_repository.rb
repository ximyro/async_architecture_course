class TaskRepository < Hanami::Repository
  associations do
    belongs_to :user
  end

  def all_with_user(user)
    aggregate(:user).where(user_id: user.id)
  end

  def all_opened
    tasks.where("status = 'created'")
  end

  def random_assinge(task_id)
    update(
      task_id,
      user_id: users.read("SELECT id FROM users where role <> 'manager' ORDER BY random() LIMIT 1;").one.id
    )
  end

  def find_with_user(task_id)
    aggregate(:user).where(id: task_id).as(Task).one
  end

  def all
    aggregate(:user)
  end
end
