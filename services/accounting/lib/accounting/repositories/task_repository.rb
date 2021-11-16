class TaskRepository < Hanami::Repository
  def find_by_public_id(public_id)
    tasks.where(public_id: public_id).one
  end

  def find_or_create_by_public_id(public_id)
    task = find_by_public_id(public_id)
    return task if task.present?

    create(public_id: public_id)
  end

  def update_costs(task_id, assignment_fee, amount)
    update(
      task_id,
      assignment_fee: assignment_fee,
      amount: amount
    )
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
