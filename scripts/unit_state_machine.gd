class_name StateMachine
const look_up_interval : float = 2.0 #how ofthn the unit with no oaction will try to look for new action - igher number increases performance
enum STATES { SUMMONING, IDLE,WALK,WORK,FIGHT,STANDBY}


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
		states[STATES.STANDBY] = StandbyState.new()
		
		for ab:Ability in unit.abilities:
			if ab.has_method("fight_process"):
				states[STATES.FIGHT].connect("fight_process",ab.fight_process)
		
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
			var action :Node2D = Priorities.get_best_action(unit)
			if action == null:
				return STATES.IDLE
				
			
			if action is Res:
					unit.current_action = action
					return STATES.WALK
			elif action is Enemy:
					unit.target = action;
					return STATES.FIGHT
					
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
		unit.agent.target_position = unit.current_action.position
		
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
	
	func set_up(_unit):
		unit = _unit
		
	func enter_state():
		print("entered work")
		
		
	func process(delta) ->STATES:
		
		if unit.current_action != null:
			if unit.current_action.work_on(delta):
				return STATES.IDLE
			return STATES.WORK
		else:
			return STATES.IDLE
		
		
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
		
		#agent = unit.agent
		#stopping_distance = unit.type.fight_range
		#unit.agent.target_position = unit.current_action.node.position
		
	func process(delta) ->STATES:
		if unit.target == null:
			return STATES.STANDBY
		unit.target_position = unit.target.position
		fight_process.emit(delta);
		return STATES.FIGHT
	func end_state():
		print("ended fight")



class StandbyState:
	extends UnitState
	var timer = 2.0
	func enter_state():
		print("entered standby")
	func process(delta) ->STATES:
		var fight = Priorities.get_fight_action(unit)
		if fight == null:
			return STATES.IDLE
		unit.target = fight
		return STATES.FIGHT
	func physics_process(delta):
		pass
	func end_state():
		pass
	





