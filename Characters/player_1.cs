using Godot;
using System;

public partial class player_1 : CharacterBody2D
{
	[Export]
	public int Speed { get; set; } = 100;

	private Vector2 direction = Vector2.Zero;
	private bool swing = false;
	private bool walking = false;

	public override void _PhysicsProcess(double _delta)
	{
		if (!swing)
		{
			Velocity = direction * Speed;
		}
		else
		{
			Velocity = Vector2.Zero;
		}
		MoveAndSlide();
	}

	public override void _Process(double delta)
	{
		//base._PhysicsProcess(delta);
		direction = Input.GetVector("left", "right", "up", "down");
		//Velocity = direction * Speed;
		if ((direction != Vector2.Zero) && !swing)
		{
			walking = true;
			SetWalking(walking);
			UpdateBlendPosition();
		}
		else
		{
			walking = false;
			SetWalking(walking);
		}

		if (Input.IsActionJustPressed("swing") && walking)
		{
			AnimationTree animationTree = GetNode<AnimationTree>("AnimationTree");
			SetSwing(true);
			animationTree.Set("parameters/conditions/walk", true);
		}
		else if (Input.IsActionJustPressed("swing") && !walking)
		{
			AnimationTree animationTree = GetNode<AnimationTree>("AnimationTree");
			SetSwing(true);
			animationTree.Set("parameters/conditions/idle", true);
		}
	}

	public void SetSwing(bool value = false)
	{
		AnimationTree animationTree = GetNode<AnimationTree>("AnimationTree");
		swing = value;
		animationTree.Set("parameters/conditions/swing", value);
	}
	public void SetWalking(bool value)
	{
		AnimationTree animationTree = GetNode<AnimationTree>("AnimationTree");
		animationTree.Set("parameters/conditions/is_walking", value);
		animationTree.Set("parameters/conditions/idle", !value);
	}
	public void UpdateBlendPosition()
	{
		AnimationTree animationTree = GetNode<AnimationTree>("AnimationTree");
		animationTree.Set("parameters/attack/blend_position", direction);
		animationTree.Set("parameters/idle/blend_position", direction);
		animationTree.Set("parameters/walk/blend_position", direction);
	}



}
