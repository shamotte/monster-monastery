class_name StateMachine
const look_up_interval : float = 2.0 #how ofthn the unit with no oaction will try to look for new action - igher number increases performance
enum STATES { SUMMONING, IDLE,WALK,WORK,FIGHT}


class UnitStateMachine:
	var current_state:UnitState
	var states:Array[UnitState]
	var cse:STATES
	func set_up(unit:Unit):
		states.resize(STATES.size())
		states[STATES.SUMMONING] = SummonigState.new()
		states[STATES.IDLE] = IdleState.new()
		states[STATES.WALK] = WalkState.new()
		states[STATES.WORK] = WorkState.new()
		states[STATES.FIGHT] = FightState.new()
		
		
		for UnitState in states:
			UnitState.set_up(unit)
		current_state = states[STATES.SUMMONING]
		current_state.enter_state()
		cse = STATES.SUMMONING
		
		
	func physics_process(delta):
		current_state.physics_process(delta)
	func process(delta):
		var new_state = current_state.process(delta)
		if new_state != cse:
			change_State(new_state)
	func change_State(new_state: STATES):
		current_state.end_state()
		current_state = states[new_state]
		current_state.enter_state()
		cse = new_state
		



class UnitState:
	var unit:Unit
	func set_up(_unit):
		unit = _unit
	func enter_state():
		pass
	func process(delta) ->STATES:
		return STATES.IDLE
	func physics_process(delta):
		pass
	func end_state():
		pass
		
class SummonigState:
	extends UnitState
	var time_left
	func set_up(_unit):
		unit = _unit
		
	func enter_state():
		time_left = unit.summoning_time
		print("summonigng started")
	func process(delta):
		time_left -= delta
		if time_left >0:
			return STATES.SUMMONING
		return STATES.IDLE
			
	func end_state():
		print("summoning ended")



class IdleState:
	extends UnitState
	var timer = 0
	func set_up(_unit):
		unit = _unit
	func enter_state():
		print("entered idle")
		timer = 0
	func process(delta) -> STATES:
		
		timer -= delta
		if timer <= 0:
			timer = look_up_interval
			unit.current_action = Priorities.get_best_action(unit)
			match unit.current_action.type:
				Priorities.ACTIONTYPES.FIGHT: return STATES.FIGHT
				_: return STATES.WALK
		return STATES.IDLE
		
	func end_state():
		print("stopped idle")
		
		
class WalkState:
	extends  UnitState
	var stopping_distance
	var agent :NavigationAgent2D
	func set_up(_unit):
		unit = _unit
	func enter_state():
		print("entered walk")
		agent = unit.agent
		stopping_distance = unit.type.work_range
		unit.agent.target_position = unit.current_action.node.position
		
	func process(delta) ->STATES:
		if agent.distance_to_target() > stopping_distance:
			return STATES.WALK
		return STATES.WORK
		
	func physics_process(delta):
		var direction = agent.get_next_path_position() - unit.global_position
		direction = direction.normalized()
		unit.velocity = unit.velocity.lerp(direction * 120  , 0.25)
		unit.move_and_slide()
	func end_state():
		print("stopped walk")
		
	

class WorkState:
	extends UnitState
	
	var work_time : float
	func set_up(_unit):
		unit = _unit
		
	func enter_state():
		print("entered work")
		work_time = unit.current_action.time
		
		
	func process(delta) ->STATES:
		work_time -=delta
		if work_time < 0 :
			unit.current_action.node.action_finished()
			unit.current_action = null # TODO CHECK whether this deletes the orginal class
			return STATES.IDLE
		return STATES.WORK
		
	func end_state():
		
		print("stopped work")
		
		
class FightState:
	extends UnitState
	
	
	signal fight_process(_unit :Unit)
	
	var agent :NavigationAgent2D
	var stopping_distance:float
	
	
	func set_up(_unit):
		unit = _unit
		
	func enter_state():
		print("entered fight")
		
		agent = unit.agent
		stopping_distance = unit.type.fight_range
		unit.agent.target_position = unit.current_action.node.position
		
	func process(delta) ->STATES:
		fight_process.emit();
		return STATES.FIGHT
	func end_state():
		print("ended fight")






