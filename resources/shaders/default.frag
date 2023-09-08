#version 330 core

struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shininess;
};

#define materialCount 4

out vec4 FragColor;

in vec3 color;
in vec2 texCoord;

in vec3 Normal;
in vec3 crntPos;

uniform sampler2D tex0;

uniform vec4 lightColor;
uniform vec3 lightPos;
uniform vec3 camPos;


uniform Material material;

void main() 
{
    float ambient = 0.35f;

    vec3 normal = normalize(Normal);
    vec3 lightDirection = normalize(lightPos - crntPos);
    float diffuse = max(dot(normal, lightDirection), 0.0f);

    float specularLight = 0.5f;
    vec3 viewDirection = normalize(camPos - crntPos);
    vec3 reflectionDirection = reflect(-lightDirection, normal);
    float specAmount = pow(max(dot(viewDirection, reflectionDirection), 0.0f), 8);
    float specular = specAmount * specularLight;

    FragColor = texture(tex0, texCoord) * lightColor * (diffuse + ambient + specular);
}