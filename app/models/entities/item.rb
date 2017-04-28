class Entities::Item < Maestrano::Connector::Rails::ComplexEntity
  def self.connec_entities_names
    %w(Item)
  end

  def self.external_entities_names
    %w(Product2 PricebookEntry)
  end

  def self.public_external_entity_name
    'Products'
  end

  # input :  {
  #             connec_entity_names[0]: [unmapped_connec_entitiy1, unmapped_connec_entitiy2],
  #             connec_entity_names[1]: [unmapped_connec_entitiy3, unmapped_connec_entitiy4]
  #          }
  # output : {
  #             connec_entity_names[0]: {
  #               external_entities_names[0]: [unmapped_connec_entitiy1, unmapped_connec_entitiy2]
  #             },
  #             connec_entity_names[1]: {
  #               external_entities_names[0]: [unmapped_connec_entitiy3],
  #               external_entities_names[1]: [unmapped_connec_entitiy4]
  #             }
  #          }
  def connec_model_to_external_model(connec_hash_of_entities)
    items = connec_hash_of_entities['Item']
    modeled_hash = {'Item' => { 'Product2' => [], 'PricebookEntry' => [] }}

    items.each do |item|
      modeled_hash['Item']['Product2'] << item
      modeled_hash['Item']['PricebookEntry'] << item
    end
    modeled_hash
  end

  # input :  {
  #             external_entities_names[0]: [unmapped_external_entity1, unmapped_external_entity2],
  #             external_entities_names[1]: [unmapped_external_entity3, unmapped_external_entity4]
  #          }
  # output : {
  #             external_entities_names[0]: {
  #               connec_entity_names[0]: [unmapped_external_entity1],
  #               connec_entity_names[1]: [unmapped_external_entity2]
  #             },
  #             external_entities_names[1]: {
  #               connec_entity_names[0]: [unmapped_external_entity3, unmapped_external_entity4]
  #             }
  #           }
  def external_model_to_connec_model(external_hash_of_entities)
    modeled_hash = {'Product2' => { 'Item' => external_hash_of_entities['Product2'] }, 'PricebookEntry' => { 'Item' => external_hash_of_entities['PricebookEntry'] }}
  end

  def self.get_pricebook_id(client)
    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Fetching standard pricebook from SalesForce")
    pricebooks = client.query("Select Id, IsStandard From Pricebook2")
    standard_pricebook = pricebooks.find { |pricebook| pricebook['IsStandard']}

    raise 'No standard pricebook found' unless standard_pricebook
    standard_pricebook['Id']
  end
end
