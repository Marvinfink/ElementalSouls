using Godot;
using System;


public partial class enemy : CharacterBody2D
{
  public int Speed = 60;
  public bool playerChase = false;
  public Node2D player = null;

  public override void _PhysicsProcess(double _delta)
  {
	AnimationTree animationTree = GetNode<AnimationTree>("AnimationTree");
	if (playerChase)
	{
	  Position += (player.Position - Position) / Speed;
	  animationTree.Set("parameters/conditions/is_walking", true);
	  animationTree.Set("parameters/conditions/idle", false);
	  MoveAndCollide(Vector2.Zero);
	}
	else
	{
	  animationTree.Set("parameters/conditions/is_walking", false);
	  animationTree.Set("parameters/conditions/idle", true);
	}
  }

  //Chase player when in zone
  public void _on_detection_area_body_entered(Node2D body)
  {
	player = body;
	playerChase = true;
  }
  //stop chasing when not in zone
  public void _on_detection_area_body_exited(Node2D body)
  {
	player = null;
	playerChase = false;
  }

	public void Enemy(){
	}
}

