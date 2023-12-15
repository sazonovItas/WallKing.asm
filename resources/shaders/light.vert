#version 330 core

layout (location = 0) in vec3 aPos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 proj;

uniform int time;
uniform int state;

void main() 
{

    vec3 normPos = aPos;
    if (state != 0) {
        float scale = sin(time / 100.0) + 0.5;
        normPos *= scale;
    }    

    gl_Position = proj * view * model * vec4(normPos, 1.0f);
}