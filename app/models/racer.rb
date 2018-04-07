class Racer

  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  include Mongoid::Document

  def id
  	@id.to_s
  end

  def mongo_client
    Mongoid::Clients.default
  end

  def initialize(params={})
  	super(params)
  	@id=params[:_id].nil? ? params[:id] : params[:_id].to_s
  	@number=params[:number].to_i
  	@first_name=params[:first_name]
  	@last_name=params[:last_name]
  	@gender=params[:gender]
  	@group=params[:group]
  	@secs=params[:secs].to_i
  end

  def collection
    self.mongo_client['racers']
  end

  def save
    Rails.logger.debug {"saving #{self}"}
    result = self.class.collection.insert_one({_id:@id,
    				  number:@number,
                      first_name:@first_name, 
                      last_name:@last_name,
                      gender:@gender,
                      group:@group,
                      secs:@secs})
    @id = result.inserted_id.to_s
  end
   
  def self.all(prototype={}, sort={:number => 1}, skip=0, limit=nil)
   result = collection.find(prototype)        
   .projection({_id:true, number:true, first_name:true, last_name:true, gender:true, group:true, secs:true})        
   .sort(sort)        
   .skip(skip)      

   result = result.limit(limit) if !limit.nil?      
   return result  
  end

  def self.find id
  	id = id.to_s
  	result = collection.find({:_id => BSON::ObjectId(id)}).first
  	return result.nil? ? nil : Racer.new(result)
  end

end
