extends VehicleBody

const MAX_STEER_ANGLE: float = 0.5
const STEER_SPEED: float = 20.0
const MAX_ENGINE_FORCE: float = 250.0
const MAX_BRAKE_FORCE: float = 10.0
const MAX_SPEED: float = 30.0

var steer_target: float = 0.0
var steer_angle: float = 0.0

# TODO: Should this live in the player script?
sync var players: Dictionary = {}
var player_data: Dictionary = {
	'steer': 0,
	'engine': 0,
	'brakes': 0,
	'position': null
}

func _ready() -> void:
	players[name] = player_data
	players[name].position = transform
	if not is_local_player():
		$Camera.queue_free()

func is_local_player() -> bool:
	return name == str(Network.local_player_id)

func _physics_process(delta: float) -> void:
	if is_local_player():
		drive(delta)
	if not Network.is_server():
		transform = players[name].position
	
	steering = players[name].steer
	engine_force = players[name].engine
	brake = players[name].brakes

func drive(delta: float) -> void:
	var steering_value = get_steer_angle(delta)
	var throttle_value = get_throttle()
	var braking_value = get_brake_strength()
	update_server(name, steering_value, throttle_value, braking_value)

func update_server(id: String, steering_value: float, throttle_value: float, braking_value: float) -> void:
	if not Network.is_server():
		rpc_unreliable_id(1, 'manage_clients', id, steering_value, throttle_value, braking_value)
	else:
		manage_clients(id, steering_value, throttle_value, braking_value)

sync func manage_clients(id: String, steering_value: float, throttle_value: float, braking_value: float) -> void:
	players[id].steer = steering_value
	players[id].engine = throttle_value
	players[id].brakes = braking_value
	players[id].position = transform
	rset_unreliable('players', players)

func get_steer_angle(delta: float) -> float: 
	var steering_input: float = Input.get_action_strength('steer_left') - Input.get_action_strength('steer_right')
	steer_target = steering_input * MAX_STEER_ANGLE
	return lerp(steer_angle, steer_target, STEER_SPEED * delta)

func get_throttle() -> float:
	if linear_velocity.length() > MAX_SPEED:
		return 0.0
	if Input.is_action_pressed('brake') and (self.linear_velocity.length() < 0.01 or self.linear_velocity.z > 0):
		return Input.get_action_strength('brake') * -MAX_ENGINE_FORCE / 2
	return Input.get_action_strength('accelerate') * MAX_ENGINE_FORCE

func get_brake_strength() -> float:
	return Input.get_action_strength('brake') * MAX_BRAKE_FORCE
