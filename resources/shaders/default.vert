#version 330 core

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;
layout (location = 2) in vec2 aTex;
layout (location = 3) in vec3 aNormal;

out vec3 color;
out vec2 TexCoords;

out vec3 Normal;
out vec3 FragPos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 proj;

void main() 
{
    FragPos = vec3(model * vec4(aPos, 1.0f));

    gl_Position = proj * view  * vec4(FragPos, 1.0);
    color = aColor;
    TexCoords = aTex;
    Normal = vec3(model * vec4(aNormal, 0.0f));
}





