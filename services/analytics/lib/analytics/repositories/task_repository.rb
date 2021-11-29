class TaskRepository < Hanami::Repository
  def find_by_public_id(public_id)
    tasks.where(public_id: public_id).one
  end

  def with_public_ids(public_ids)
    tasks.where(public_id: public_ids)
  end

  def create_or_update_by_public_id(public_id, data)
    task = find_by_public_id(public_id)

    attributes = {
      title: data['title'],
      description: data['description'],
      assigned_user_id: data['assigned_user_id'],
      status: data['status'],
      jira_id: data['jira_id']
    }
    if task
      return update(
        task.id,
        attributes
      )
    end

    attributes[:public_id] = public_id
    create(attributes)
  end
end
