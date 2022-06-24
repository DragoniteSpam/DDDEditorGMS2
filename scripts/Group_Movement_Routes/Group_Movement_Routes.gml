function MoveRoute(source) : SData(source) constructor {
    self.repeat_action = false;
    self.skip = true;
    self.wait = true;
    
    // array of structs
    self.steps = [];
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_field, pack(
            self.repeat_action,
            self.skip,
            self.wait
        ));
        buffer_write(buffer, buffer_u16, array_length(self.steps));
        
        for (var i = 0, n = array_length(self.steps); i < n; i++) {
            buffer_write(buffer, buffer_s32, self.steps[i].id);
            self.steps[i].Export(buffer);
        }
    };
    
    if (is_struct(source)) {
        self.repeat_action = source.repeat_action;
        self.skip = source.skip;
        self.wait = source.wait;
        self.steps = source.steps;
    }
}

function MoveRouteAction() {
    self.name = "base action";
    self.action_id = -1;
    
    self.toString = function() {
        return self.name;
    };
    
    self.Edit = function() { };
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_u32, self.action_id);
    };
    
    self.Edit();
}

function MoveRouteAction_MoveDown() : MoveRouteAction() constructor {
    self.name = "Move Down";
    self.action_id = MoveRouteActions.MOVE_DOWN;
}
function MoveRouteAction_MoveLeft() : MoveRouteAction() constructor {
    self.name = "Move Left";
    self.action_id = MoveRouteActions.MOVE_LEFT;
}
function MoveRouteAction_MoveRight() : MoveRouteAction() constructor {
    self.name = "Move Right";
    self.action_id = MoveRouteActions.MOVE_RIGHT;
}
function MoveRouteAction_MoveUp() : MoveRouteAction() constructor {
    self.name = "Move Up";
    self.action_id = MoveRouteActions.MOVE_UP;
}
function MoveRouteAction_MoveLowerLeft() : MoveRouteAction() constructor {
    self.name = "Move Lower Left";
    self.action_id = MoveRouteActions.MOVE_LOWER_LEFT;
}
function MoveRouteAction_MoveLowerRight() : MoveRouteAction() constructor {
    self.name = "Move Lower Right";
    self.action_id = MoveRouteActions.MOVE_LOWER_RIGHT;
}
function MoveRouteAction_MoveUpperLeft() : MoveRouteAction() constructor {
    self.name = "Move Upper Left";
    self.action_id = MoveRouteActions.MOVE_UPPER_LEFT;
}
function MoveRouteAction_MoveUpperRight() : MoveRouteAction() constructor {
    self.name = "Move Upper Right";
    self.action_id = MoveRouteActions.MOVE_UPPER_RIGHT;
}
function MoveRouteAction_MoveRandom() : MoveRouteAction() constructor {
    self.name = "Move Randomly";
    self.action_id = MoveRouteActions.MOVE_RANDOM;
}
function MoveRouteAction_MoveTowardsPlayer() : MoveRouteAction() constructor {
    self.name = "Move Towards Player";
    self.action_id = MoveRouteActions.MOVE_TOWARDS_PLAYER;
}
function MoveRouteAction_MoveAwayFromPlayer() : MoveRouteAction() constructor {
    self.name = "Move Away From Player";
    self.action_id = MoveRouteActions.MOVE_AWAY_PLAYER;
}
function MoveRouteAction_MoveForward() : MoveRouteAction() constructor {
    self.name = "Move Forward";
    self.action_id = MoveRouteActions.MOVE_FORWARD;
}
function MoveRouteAction_MoveBackward() : MoveRouteAction() constructor {
    self.name = "Move Backward";
    self.action_id = MoveRouteActions.MOVE_BACKWARD;
}
function MoveRouteAction_MoveTo() : MoveRouteAction() constructor {
    self.name = "Move To Position";
    self.action_id = MoveRouteActions.MOVE_TO_POSITION;
    
    self.x = 0;
    self.y = 0;
    self.z = 0;
    self.direction = 0;
    
    self.toString = function() {
        return "Move to (" + string(self.x) + ", " + string(self.y) + ", " + string(self.z) + ") facing " + string(global.rpg_maker_directions[self.direction]);
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_u32, self.x);
        buffer_write(buffer, buffer_u32, self.y);
        buffer_write(buffer, buffer_u32, self.z);
        buffer_write(buffer, buffer_u8, self.direction);
    };
    
    self.Edit();
}
function MoveRouteAction_Jump() : MoveRouteAction() constructor {
    self.name = "Jump";
    self.action_id = MoveRouteActions.MOVE_JUMP;
    
    self.height = 1;
    
    self.toString = function() {
        return "Jump: " + string(self.height) + " cells/second";
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_f32, self.height);
    };
    
    self.Edit();
}
function MoveRouteAction_Wait() : MoveRouteAction() constructor {
    self.name = "Wait";
    self.action_id = MoveRouteActions.WAIT;
    
    self.duration = 1;
    
    self.toString = function() {
        return "Wait: " + string(self.duration);
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_f32, self.duration);
    };
    
    self.Edit();
}
function MoveRouteAction_TurnDown() : MoveRouteAction() constructor {
    self.name = "Turn Down";
    self.action_id = MoveRouteActions.TURN_DOWN;
}
function MoveRouteAction_TurnLeft() : MoveRouteAction() constructor {
    self.name = "Turn Left";
    self.action_id = MoveRouteActions.TURN_LEFT;
}
function MoveRouteAction_TurnRight() : MoveRouteAction() constructor {
    self.name = "Turn Right";
    self.action_id = MoveRouteActions.TURN_RIGHT;
}
function MoveRouteAction_TurnUp() : MoveRouteAction() constructor {
    self.name = "Turn Up";
    self.action_id = MoveRouteActions.TURN_UP;
}
function MoveRouteAction_Turn90Left() : MoveRouteAction() constructor {
    self.name = "Turn 90° Left";
    self.action_id = MoveRouteActions.TURN_90_LEFT;
}
function MoveRouteAction_Turn90Right() : MoveRouteAction() constructor {
    self.name = "Turn 90° Right";
    self.action_id = MoveRouteActions.TURN_90_RIGHT;
}
function MoveRouteAction_Turn180() : MoveRouteAction() constructor {
    self.name = "Turn 180°";
    self.action_id = MoveRouteActions.TURN_180;
}
function MoveRouteAction_TurnLeftOrRight() : MoveRouteAction() constructor {
    self.name = "Turn Left Or Right";
    self.action_id = MoveRouteActions.TURN_90_RANDOM;
}
function MoveRouteAction_TurnRandom() : MoveRouteAction() constructor {
    self.name = "Turn Randomly";
    self.action_id = MoveRouteActions.TURN_RANDOM;
}
function MoveRouteAction_TurnTowardsPlayer() : MoveRouteAction() constructor {
    self.name = "Turn Towards the Player";
    self.action_id = MoveRouteActions.TURN_TOWARD_PLAYER;
}
function MoveRouteAction_TurnAwayFromPlayer() : MoveRouteAction() constructor {
    self.name = "Turn Away From the Player";
    self.action_id = MoveRouteActions.TURN_AWAY_PLAYER;
}
function MoveRouteAction_SelfSwitch() : MoveRouteAction() constructor {
    self.name = "Self Switch";
    self.action_id = MoveRouteActions.SWITCH;
    
    self.index = 0;
    self.value = true;
    
    self.toString = function() {
        return "Set Self Switch " + chr(ord("A") + self.index) + " to " + (self.value ? "True" : "False");
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_u8, self.index);
        buffer_write(buffer, buffer_u8, self.value);
    };
    
    self.Edit();
}
function MoveRouteAction_SelfVariable() : MoveRouteAction() constructor {
    self.name = "Self Variable";
    self.action_id = MoveRouteActions.VARIABLE;
    
    self.index = 0;
    self.value = true;
    
    self.toString = function() {
        return "Set Self Variable " + chr(ord("A") + self.index) + " to " + string(self.value);
    };
    
    self.Edit = function() {
        
    };
    
    self.Edit();
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_u8, self.index);
        buffer_write(buffer, buffer_f32, self.value);
    };
    
    self.Edit();
}
function MoveRouteAction_SetSpeed() : MoveRouteAction() constructor {
    self.name = "Set Speed";
    self.action_id = MoveRouteActions.CHANGE_SPEED;
    
    self.speed = 2;
    
    self.toString = function() {
        return "Set Movement Speed to " + string(self.speed);
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_u8, self.speed);
    };
    
    self.Edit();
}
function MoveRouteAction_SetFrequency() : MoveRouteAction() constructor {
    self.name = "Set Frequency";
    self.action_id = MoveRouteActions.CHANGE_FREQUENCY;
    
    self.frequency = 2;
    
    self.toString = function() {
        return "Set Movement Frequency to " + string(self.frequency);
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_u8, self.frequency);
    };
    
    self.Edit();
}
function MoveRouteAction_SetStepping() : MoveRouteAction() constructor {
    self.name = "Set Stepping Animation";
    self.action_id = MoveRouteActions.STEPPING_ANIM;
    
    self.value = false;
    
    self.toString = function() {
        return "Set Stepping Animation to " + (self.value ? "True" : "False");
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_u8, self.value);
    };
    
    self.Edit();
}
function MoveRouteAction_SetWalking() : MoveRouteAction() constructor {
    self.name = "Set Walking Animation";
    self.action_id = MoveRouteActions.WALKING_ANIM;
    
    self.value = false;
    
    self.toString = function() {
        return "Set Walking Animation to " + (self.value ? "True" : "False");
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_u8, self.value);
    };
    
    self.Edit();
}
function MoveRouteAction_SetDirectionFix() : MoveRouteAction() constructor {
    self.name = "Set Direction Fix";
    self.action_id = MoveRouteActions.DIRECTION_FIX;
    
    self.value = false;
    
    self.toString = function() {
        return "Set Direction Fix to " + (self.value ? "True" : "False");
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_u8, self.value);
    };
    
    self.Edit();
}
function MoveRouteAction_SetSprite() : MoveRouteAction() constructor {
    self.name = "Set Sprite";
    self.action_id = MoveRouteActions.CHANGE_SPRITE;
    
    self.sprite = NULL;
    
    self.toString = function() {
        return "Set SpriteRenderer to " + (guid_get(self.sprite) ? guid_get(self.sprite).name : "<none>");
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_datatype, self.sprite);
    };
    
    self.Edit();
}
function MoveRouteAction_SetMesh() : MoveRouteAction() constructor {
    self.name = "Set Mesh";
    self.action_id = MoveRouteActions.CHANGE_MODEL;
    
    self.mesh = NULL;
    
    self.toString = function() {
        return "Set MeshRenderer to " + (guid_get(self.mesh) ? guid_get(self.mesh).name : "<none>");
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_datatype, self.mesh);
    };
    
    self.Edit();
}
function MoveRouteAction_SetOpacity() : MoveRouteAction() constructor {
    self.name = "Set Opacity";
    self.action_id = MoveRouteActions.CHANGE_OPACITY;
    
    self.alpha = 1;
    
    self.toString = function() {
        return "Set opacity to " + string(round(self.alpha * 100)) + "%";
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_f32, self.alpha);
    };
    
    self.Edit();
}
function MoveRouteAction_SetTint() : MoveRouteAction() constructor {
    self.name = "Set Tint";
    self.action_id = MoveRouteActions.CHANGE_TINT;
    
    self.tint = c_white;
    
    self.toString = function() {
        return "Set tint to #" + string_hex(colour_reverse(self.tint), 6) + " [#" + string_hex(colour_reverse(self.tint)) + "][spr_color_window]";
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_u32, self.tint);
    };
    
    self.Edit();
}
function MoveRouteAction_PlaySound() : MoveRouteAction() constructor {
    self.name = "Play Sound";
    self.action_id = MoveRouteActions.PLAY_SE;
    
    self.sound = NULL;
    self.loop = false;
    
    self.toString = function() {
        return "Play sound: " + (guid_get(self.sound) ? guid_get(self.sound).name : "<none>") + (self.loop ? " on loop" : "");
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_datatype, self.sound);
        buffer_write(buffer, buffer_u8, self.loop);
    };
    
    self.Edit();
}
function MoveRouteAction_Event() : MoveRouteAction() constructor {
    self.name = "Play Event";
    self.action_id = MoveRouteActions.EVENT;
    
    self.event = NULL;
    
    self.toString = function() {
        return "Play Event: " + (guid_get(self.event) ? guid_get(self.event).event.name + "/" + guid_get(self.event).name : "<none>");
    };
    
    self.Edit = function() {
        
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_datatype, self.event);
    };
    
    self.Edit();
}

enum MoveRouteActions {
    MOVE_DOWN,
    MOVE_LEFT,
    MOVE_RIGHT,
    MOVE_UP,
    MOVE_LOWER_LEFT,
    MOVE_LOWER_RIGHT,
    MOVE_UPPER_LEFT,
    MOVE_UPPER_RIGHT,
    MOVE_RANDOM,
    MOVE_TOWARDS_PLAYER,
    MOVE_AWAY_PLAYER,
    MOVE_FORWARD,
    MOVE_BACKWARD,
    MOVE_JUMP,
    MOVE_TO_POSITION,
    
    WAIT,
    
    TURN_DOWN,
    TURN_LEFT,
    TURN_RIGHT,
    TURN_UP,
    TURN_90_RIGHT,
    TURN_90_LEFT,
    TURN_180,
    TURN_90_RANDOM,
    TURN_RANDOM,
    TURN_TOWARD_PLAYER,
    TURN_AWAY_PLAYER,
    
    SWITCH,
    VARIABLE,
    CHANGE_SPEED,
    CHANGE_FREQUENCY,
    
    WALKING_ANIM,
    STEPPING_ANIM,
    DIRECTION_FIX,
    
    CHANGE_SPRITE,
    CHANGE_MODEL,
    CHANGE_OPACITY,
    CHANGE_TINT,
    PLAY_SE,
    
    EVENT,
}
