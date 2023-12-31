#version 330 core
#define NR_POINT_LIGHTS 10  

struct PointLight {    
    vec3 position;
    vec3 color;
    
    float constant;
    float linear;
    float quadratic;  

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};  
uniform int CntPointLights;
uniform PointLight pointLights[NR_POINT_LIGHTS];

out vec4 FragColor;

in vec2 TexCoords;
in vec3 Normal;
in vec3 FragPos;

struct Material {
    sampler2D ambient;
    sampler2D diffuse;
    sampler2D specular;
    float shininess;
}; 
uniform Material material;

uniform vec3 camPos;

vec3 CalcPointLight(PointLight light, vec3 normal, vec3 fragPos, vec3 viewDir)
{

    vec3 lightDir = normalize(light.position - fragPos);
    // diffuse shading
    float diff = max(dot(normal, lightDir), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    // attenuation
    float distance    = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance + 
  			     light.quadratic * (distance * distance));    
    // combine results
    vec3 ambient  = (light.ambient * light.color) * vec3(texture(material.diffuse, TexCoords));
    vec3 diffuse  = (light.diffuse * light.color) * diff * vec3(texture(material.diffuse, TexCoords));
    vec3 specular = (light.specular * light.color) * spec * vec3(texture(material.specular, TexCoords));
    ambient  *= attenuation;
    diffuse  *= attenuation;
    specular *= attenuation;
    return (ambient + diffuse + specular);
} 

void main() 
{
    vec3 norm = normalize(Normal);
    vec3 viewDir = normalize(camPos - FragPos);

    vec3 result = vec3(0.0);

    for(int i = 0; i < CntPointLights; i++) {
        result += CalcPointLight(pointLights[i], norm, FragPos, viewDir);
    }

    FragColor = vec4(result, 1.0);
}