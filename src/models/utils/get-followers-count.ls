require! {
	'../user-following': UserFollowing
}

module.exports = (user-id) ->
	resolve, reject <- new Promise!
	err, count <- UserFollowing.count {followee-id: user-id}
	if err?
		then reject err
		else resolve count
