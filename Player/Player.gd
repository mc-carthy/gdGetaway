extends VehicleBody

const MAX_STEER_ANGLE: float = 0.35
const STEER_SPEED: float = 20.0
const MAX_ENGINE_FORCE: float = 175.0
const MAX_BRAKE_FORCE: float = 10.0

var steer_target: float = 0.0
var steer_angle: float = 0.0

func _physics_process(delta: float) -> void:
	drive(delta)

func drive(delta: float) -> void:
	steering = get_steer_angle(delta)
	engine_force = get_throttle()
	brake = get_brake_strength()

func get_steer_angle(delta: float) -> float: 
	var steering_input: float = Input.get_action_strength('steer_left') - Input.get_action_strength('steer_right')
	steer_target = steering_input * MAX_STEER_ANGLE
	return lerp(steer_angle, steer_target, STEER_SPEED * delta)

func get_throttle() -> float:
	if Input.is_action_pressed('brake') and (self.linear_velocity.length() < 0.01 or self.linear_velocity.z > 0):
		return Input.get_action_strength('brake') * -MAX_ENGINE_FORCE / 2
	return Input.get_action_strength('accelerate') * MAX_ENGINE_FORCE

func get_brake_strength() -> float:
	return Input.get_action_strength('brake') * MAX_BRAKE_FORCE
