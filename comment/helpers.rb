
def obj_id(val)
  begin
    BSON::ObjectId.from_string(val)
  rescue BSON::ObjectId::Invalid
    nil
  end
end

def document_by_id(id)
  id = obj_id(id) if String === id
  if id.nil?
    {}.to_json
  else
    document = settings.mongo_db.find(:_id => id).to_a.first
    (document || {}).to_json
  end
end

def healthcheck(mongo_host, mongo_port)
  begin
    commentdb_test = Mongo::Client.new(["#{mongo_host}:#{mongo_port}"], server_selection_timeout: 2)
    commentdb_test.database_names
    commentdb_test.close
  rescue
    commentdb_status = 0
  else
    commentdb_status = 1
  end

  status = commentdb_status

  version = File.read('VERSION')

  healthcheck = {
    status: status,
    dependent_services: {
      commentdb: commentdb_status
    },
    version: version
  }

  healthcheck.to_json
end
