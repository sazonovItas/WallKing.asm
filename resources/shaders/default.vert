#version 330 core

layout (location = 0) in vec3 aPos;

void main() 
{
    float scale = 0.5;
    gl_Position = vec4(aPos.x * scale, aPos.y * scale, aPos.z * scale, 1.0);
}