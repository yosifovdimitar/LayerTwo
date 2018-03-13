defmodule LayertwoDb.ChannelCityLocalQueries do


  def get_entity_channel_permission_and_ws_uuid(socket) do
    entity_uuid = socket.assigns["entity_uuid"]

    db_query = "MATCH (Entity:Entity {entity_uuid: {entity_param}})
                RETURN Entity.channel_city_local, Entity.entity_ws_uuid"

    db_query_params = %{entity_param: entity_uuid}

    db_conn = Bolt.Sips.conn()
    db_query_result = Bolt.Sips.query(db_conn, db_query, db_query_params)

    case db_query_result do
      {:ok, []} -> {:error, socket}
      {:error, _reason} -> {:error, socket}
      {:ok, [%{"Entity.channel_city_local" => db_entity_channel_permission,
               "Entity.entity_ws_uuid" => db_entity_ws_uuid}]} -> {:ok, socket, db_entity_channel_permission, db_entity_ws_uuid}
    end
  end


  def get_entity_latitude_longitude(socket)
    do
    entity_uuid = socket.assigns["entity_uuid"]

    db_query =
      "MATCH (Entity:Person {entity_uuid: {entity_param}}) return Entity.entity_latitude, Entity.entity_longitude"

    db_query_params = %{entity_param: entity_uuid}

    db_conn = Bolt.Sips.conn()
    db_query_result = Bolt.Sips.query(db_conn, db_query, db_query_params)

    case db_query_result do
      {:ok, []} -> {:error, socket}

      {:error, _reason} -> {:error, socket}

      {:ok,[%{
           "Entity.entity_latitude" => db_entity_latitude,
           "Entity.entity_longitude" => db_entity_longitude
            }]} ->
        {:ok, socket, db_entity_latitude, db_entity_longitude}
    end
  end

  def get_local_problem_latitude_longitude(local_problem_uuid, socket)
  do
    db_query =
      "MATCH (LocalProblem:LocalProblem {local_problem_uuid: {local_problem_uuid}})
       RETURN LocalProblem.local_problem_latitude, LocalProblem.local_problem_longitude"

    db_query_params = %{local_problem_uuid: local_problem_uuid}

    db_conn = Bolt.Sips.conn()
    db_query_result = Bolt.Sips.query(db_conn, db_query, db_query_params)

    case db_query_result do
      {:ok, []} -> {:error, socket}

      {:error, _reason} -> {:error, socket}

      {:ok,[%{
           "LocalProblem.local_problem_latitude" => db_local_problem_latitude,
           "LocalProblem.local_problem_longitude" => db_local_problem_longitude
            }]} ->
        {:ok, socket, db_local_problem_latitude, db_local_problem_longitude}
    end
  end

  def get_local_problem_description(local_problem_uuid, socket)
  do
    db_query =
    "MATCH (LocalProblem:LocalProblem {local_problem_uuid: {local_problem_uuid}})
     RETURN LocalProblem.local_problem_description"

  db_query_params = %{local_problem_uuid: local_problem_uuid}

  db_conn = Bolt.Sips.conn()
  db_query_result = Bolt.Sips.query(db_conn, db_query, db_query_params)

  case db_query_result do
    {:ok, []} -> {:error, socket}

    {:error, _reason} -> {:error, socket}

    {:ok,[%{
         "LocalProblem.local_problem_description" => db_local_problem_description
          }]} ->
      {:ok, socket, db_local_problem_description}
  end
  end

  def save_local_problem_db(
        local_problem_title_valid,
        local_problem_importance_int_valid,
        local_problem_description_valid,
        local_problem_latitude_safe_float_valid,
        local_problem_longitude_safe_float_valid,
        socket)
    do
    entity_uuid = socket.assigns["entity_uuid"]
    local_problem_uuid = UUID.uuid4()
    local_problems_name = "Local Problems"

    db_query = "MATCH (Entity:Person {entity_uuid: {entity_param}})-[:ENTITY_IN]->(City:City)<-[:CITY_LOCAL]-(CityLocal:CityLocal)
                             MERGE (LocalProblems:LocalProblems{name: {local_problems_name}})-[:LOCAL_PROBLEMS_IN]->(CityLocal)
                             MERGE (Entity)-[:LOCAL_PROBLEM_AUTHOR]->(LocalProblem:LocalProblem {local_problem_uuid: {local_problem_uuid},
                             local_problem_title: {local_problem_title}, local_problem_importance:{local_problem_importance}, local_problem_description: {local_problem_description},
                             local_problem_latitude: {local_problem_latitude}, local_problem_longitude: {local_problem_longitude},
                             timestamp: timestamp()})-[:LOCAL_PROBLEM]->(LocalProblems)
                             RETURN LocalProblem.local_problem_title, City.city_uuid"

    db_query_params = %{
      entity_param: entity_uuid,
      local_problem_uuid: local_problem_uuid,
      local_problem_title: local_problem_title_valid,
      local_problem_importance: local_problem_importance_int_valid,
      local_problem_description: local_problem_description_valid,
      local_problem_latitude: local_problem_latitude_safe_float_valid,
      local_problem_longitude: local_problem_longitude_safe_float_valid,
      local_problems_name: local_problems_name}

    db_conn = Bolt.Sips.conn()
    db_query_result = Bolt.Sips.query(db_conn, db_query, db_query_params)

    case db_query_result do
      {:ok, []} -> {:error, socket}
      {:error, _reason} -> {:error, socket}
      {:ok, [%{"LocalProblem.local_problem_title" => ^local_problem_title_valid,
               "City.city_uuid" => city_uuid}]} -> {:ok, socket, city_uuid}
    end
  end

  def update_local_problem_db(
        local_problem_uuid,
        local_problem_title_valid,
        local_problem_importance_int_valid,
        local_problem_description_valid,
        local_problem_latitude_safe_float_valid,
        local_problem_longitude_safe_float_valid,
        socket)
    do
    entity_uuid = socket.assigns["entity_uuid"]
    local_problems_name = "Local Problems"

    db_query = "MATCH (:Person {entity_uuid: {entity_param}})-[:ENTITY_IN]->(City:City)<-[:CITY_LOCAL]-(:CityLocal)<-[:LOCAL_PROBLEMS_IN]-(:LocalProblems)<-[:LOCAL_PROBLEM]-(LocalProblem:LocalProblem{local_problem_uuid: {local_problem_uuid}})
                SET LocalProblem += {local_problem_title: {local_problem_title},
                                     local_problem_importance: {local_problem_importance},
                                     local_problem_description:  {local_problem_description},
                                     local_problem_latitude: {local_problem_latitude},
                                     local_problem_longitude: {local_problem_longitude}}
                RETURN City.city_uuid, LocalProblem.local_problem_uuid"

    db_query_params = %{
      entity_param: entity_uuid,
      local_problem_uuid: local_problem_uuid,
      local_problem_title: local_problem_title_valid,
      local_problem_importance: local_problem_importance_int_valid,
      local_problem_description: local_problem_description_valid,
      local_problem_latitude: local_problem_latitude_safe_float_valid,
      local_problem_longitude: local_problem_longitude_safe_float_valid,
      local_problems_name: local_problems_name}

    db_conn = Bolt.Sips.conn()
    db_query_result = Bolt.Sips.query(db_conn, db_query, db_query_params)

    case db_query_result do
      {:ok, []} -> {:error, socket}
      {:error, _reason} -> {:error, socket}
      {:ok, [%{"City.city_uuid" => city_uuid,
               "LocalProblem.local_problem_uuid" => ^local_problem_uuid}]} -> {:ok, socket, city_uuid, local_problem_uuid}
    end
  end

  def get_entity_local_problems(socket) do
    entity_uuid = socket.assigns["entity_uuid"]

    db_query =
      "MATCH (Entity:Person{entity_uuid:{entity_param}})-[:ENTITY_IN]->(City:City)
       MATCH (:City{city_name: City.city_name, admin_0: City.admin_0})<-[:CITY_LOCAL]-(:CityLocal)<-[:LOCAL_PROBLEMS_IN]-(:LocalProblems)<-[:LOCAL_PROBLEM]-(LocalProblem:LocalProblem)<-[:LOCAL_PROBLEM_AUTHOR]-(LocalProblemAuthor)
       WHERE Entity.entity_latitude-0.00075 <= LocalProblem.local_problem_latitude
       AND Entity.entity_latitude+0.00075 >= LocalProblem.local_problem_latitude
       AND Entity.entity_longitude-0.00100 <= LocalProblem.local_problem_longitude
       AND Entity.entity_longitude+0.00100 >= LocalProblem.local_problem_longitude
       RETURN LocalProblem.local_problem_title,
              LocalProblem.local_problem_importance,
              LocalProblem.local_problem_uuid,
              LocalProblem.timestamp,
              LocalProblem.local_problem_latitude,
              LocalProblem.local_problem_longitude,
              LocalProblemAuthor.entity_uuid"

    db_query_params = %{entity_param: entity_uuid}

    db_conn = Bolt.Sips.conn()
    db_query_result = Bolt.Sips.query(db_conn, db_query, db_query_params)

    case db_query_result do
      {:ok, []} -> local_problems_list = "none"
                  {:ok, socket, local_problems_list}

      {:error, _reason} -> {:error, socket}

      {:ok, local_problems_list} -> {:ok, socket, local_problems_list}
    end
  end

  def get_local_problem_author_uuid(local_problem_uuid, socket) do
      db_query =
      "MATCH (:LocalProblem {local_problem_uuid: {local_problem_uuid}})<-[:LOCAL_PROBLEM_AUTHOR]-(LocalProblemAuthor)
       RETURN LocalProblemAuthor.entity_uuid"

    db_query_params = %{local_problem_uuid: local_problem_uuid}

    db_conn = Bolt.Sips.conn()
    db_query_result = Bolt.Sips.query(db_conn, db_query, db_query_params)

    case db_query_result do
      {:ok, []} -> {:error, socket}

      {:error, _reason} -> {:error, socket}

      {:ok,[%{
           "LocalProblemAuthor.entity_uuid" => db_local_problem_author_uuid
            }]} ->
        {:ok, socket, db_local_problem_author_uuid}
    end
  end

  def get_local_problem_city_uuid(local_problem_uuid, socket) do
    db_query =
    "MATCH (:LocalProblem {local_problem_uuid: {local_problem_uuid}})-[:LOCAL_PROBLEM]->(:LocalProblems)-[:LOCAL_PROBLEMS_IN]->(:CityLocal)-[:CITY_LOCAL]->(LocalProblemCity)
     RETURN LocalProblemCity.city_uuid"

  db_query_params = %{local_problem_uuid: local_problem_uuid}

  db_conn = Bolt.Sips.conn()
  db_query_result = Bolt.Sips.query(db_conn, db_query, db_query_params)

  case db_query_result do
    {:ok, []} -> {:error, socket}

    {:error, _reason} -> {:error, socket}

    {:ok,[%{
         "LocalProblemCity.city_uuid" => db_local_problem_city_uuid
          }]} ->
      {:ok, socket, db_local_problem_city_uuid}
    end
  end

  def delete_local_problem(local_problem_uuid, socket) do
    db_query =
    "MATCH (LocalProblem:LocalProblem{local_problem_uuid:{local_problem_uuid}}) DETACH DELETE LocalProblem RETURN true"

  db_query_params = %{local_problem_uuid: local_problem_uuid}

  db_conn = Bolt.Sips.conn()
  db_query_result = Bolt.Sips.query(db_conn, db_query, db_query_params)

  case db_query_result do
    {:ok, []} -> {:error, socket}

    {:error, _reason} -> {:error, socket}

    {:ok,[%{
         "true" => db_local_problem_deletion_result
          }]} ->
      {:ok, socket, db_local_problem_deletion_result}
  end
  end

  def get_list_of_entities(city_uuid, local_problem_latitude_float_valid, local_problem_longitude_float_valid, socket) do

    db_query =
      "MATCH (:City{city_uuid: {city_uuid_param}})<-[:ENTITY_IN]-(Entity:Person)
       WHERE Entity.entity_latitude >= {local_problem_latitude}-0.00075
       AND  Entity.entity_latitude <= {local_problem_latitude}+0.00075
       AND Entity.entity_longitude >= {local_problem_longitude}-0.00100
       AND Entity.entity_longitude <= {local_problem_longitude}+0.00100
       RETURN Entity.entity_ws_uuid"

    db_query_params = %{city_uuid_param: city_uuid,
                        local_problem_latitude: local_problem_latitude_float_valid,
                        local_problem_longitude: local_problem_longitude_float_valid}

    db_conn = Bolt.Sips.conn()
    db_query_result = Bolt.Sips.query(db_conn, db_query, db_query_params)

    case db_query_result do
      {:ok, []} -> notify_entities_list = "none"
                  {:ok, socket, notify_entities_list}

      {:error, _reason} -> {:error, socket}

      {:ok, notify_entities_list} -> {:ok, socket, notify_entities_list}
    end
  end

end