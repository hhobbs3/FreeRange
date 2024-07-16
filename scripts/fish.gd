extends Area2D

@onready var polygon_2d = $Polygon2D
@onready var collision_polygon_2d = $CollisionPolygon2D
@onready var folder_rays = $FolderRays.get_children()
var boidsSeen := []
var vel := Vector2.ZERO
var speed := 7.0
var screensize : Vector2
var movv := 48


# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport_rect().size
	randomize()
	# collision_polygon_2d.polygon = polygon_2d.polygon
	# var points = [Vector2(100,100), Vector2(200,100), Vector2(200,200),Vector2(100,200)]
	# var color = [Color(0, 0, 0, 1)]
	# draw_polygon(points,color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	boids()
	checkCollision()
	vel = vel.normalized() * speed
	move()
	rotation = lerp_angle(rotation, vel.angle_to_point(Vector2.ZERO), 0.4)

func boids() -> void:
	if boidsSeen:
		var numOfBoids := boidsSeen.size()
		var avgVel := Vector2.ZERO
		var avgPos := Vector2.ZERO
		var steerAway := Vector2.ZERO
		for boid in boidsSeen:
			avgVel += boid.vel
			avgPos += boid.position
			steerAway -= (boid.global_position - global_position) * (movv/( global_position- boid.global_position).length())

		avgVel /= numOfBoids
		vel += (avgVel - vel)/2

		avgPos /= numOfBoids
		vel += (avgPos - position)

		steerAway /= numOfBoids
		vel += (steerAway)


func checkCollision() -> void:
	for ray in folder_rays:
		var r : RayCast2D = ray
		if r.is_colliding():
			if r.get_collider().is_in_group("blocks"):
				var magni := (100/(r.get_collision_point() - global_position).length_squared())
				vel -= (r.target_position.rotated(rotation) * magni)
		pass
	
func move() -> void:
	global_position += vel
	if global_position.x < 0:
		global_position.x = screensize.x
	if global_position.x > screensize.x:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = screensize.y
	if global_position.y > screensize.y:
		global_position.y = 0
	
func _on_vision_area_entered(area: Area2D) -> void:
	if area != self and area.is_in_group("boid"):
		boidsSeen.append(area)


func _on_vision_area_exited(area: Area2D) -> void:
	if area:
		boidsSeen.erase(area)


func _on_boid_body_entered(body: Node) -> void:
	if body:
		print("hit smth :(")
