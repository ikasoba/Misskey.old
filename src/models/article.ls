require! {
	mongoose
	'mongoose-auto-increment'
	'../config'
}

db = mongoose.connect config.mongo.uri, config.mongo.options

comment-schema = new mongoose.Schema do
	content: { type: String, required: yes }
	created-at: { type: Date, required: yes }
	user-id: { type: Number, required: yes }

article-schema = new mongoose.Schema do
	comments: [comment-schema]
	content: { type: String, required: yes }
	created-at: { type: Date, default: Date.now, required: yes }
	user-id: { type: Number, required: yes }

# Virtual access _id property 
article-schema.virtual \id .get -> (@_id)

# Auto increment
article-schema.plugin mongoose-auto-increment.plugin, { model: \Article, field: \_id }

exports = db.model \Article article-schema
