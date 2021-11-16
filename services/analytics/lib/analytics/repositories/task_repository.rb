class TaskRepository < Hanami::Repository
  def find_by_public_id(public_id)
    tasks.where(public_id: public_id).one
  end

  def create_or_update_by_public_id(public_id, data)
    task = find_by_public_id(public_id)
    if task
      return update(
        task.id,
        title: data['title'],
        description: data['description'],
        assigned_user_id: data['assigned_user_id'],
        status: data['status']
      )
    end

    create(
      public_id: data['public_id'],
      title: data['title'],
      description: data['description'],
      assigned_user_id: data['assigned_user_id'],
      status: data['status']
    )
  end
end
