using Godot;
using System;
using System.Threading;

public partial class player_1 : CharacterBody2D
{
	[Export]
	public int Speed { get; set; } = 100;

	//Player walking attacking
	private Vector2 direction = Vector2.Zero;
	private bool swing = false;
	private bool walking = false;

	//Player fighting
	private bool inAttackRange = false;
	private bool enemyAttackCooldown = false;
	private int health = 100;
	private bool playerAlive = true;


	public override void _PhysicsProcess(double _delta)
	{
		if(health<=0){
			playerAlive=false;
			health=0;
			GD.Print("player is died");
		}
		enemyAttack();
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
			GD.Print("attack!");
			AnimationTree animationTree = GetNode<AnimationTree>("AnimationTree");
			SetSwing(true);
			animationTree.Set("parameters/conditions/walk", true);
		}
		else if (Input.IsActionJustPressed("swing") && !walking)
		{
			GD.Print("attack!");
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


	public void player()
	{

	}

	private void _on_player_hitbox_body_entered(Node2D body)
	{
		if (body.HasMethod("Enemy"))
		{
			GD.Print("player took damage");
			inAttackRange = true;
		}
	}

	private void _on_player_hitbox_body_exited(Node2D body)
	{
		if (body.HasMethod("Enemy"))
		{
			inAttackRange = false;
		}
	}

	public void enemyAttack()
	{
		if (inAttackRange && enemyAttackCooldown == true)
		{
			health -= 20;
			enemyAttackCooldown = false;
			Godot.Timer AttackCooldown = (Godot.Timer)GetNode("attackCooldown");
			//AttackCooldown=GetNode<Godot.Timer>("./attackCooldown");
			AttackCooldown.Start();
			GD.Print(health);
		}
	}
	private void _on_attack_cooldown_timeout()
	{
		enemyAttackCooldown=true;
	}

}




