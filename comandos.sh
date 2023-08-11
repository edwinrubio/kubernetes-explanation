#generate the key
openssl genrsa -out allfait.key 2048

#generacion de certificado
openssl req -new -key allfait.key -out allfait.csr -subj "/CN=allfait/O=dev/O=example.org"

#Es necesario que cada uno obtenga de su config file el CA y el CAKey del cluster en el caso de docker desktop es necesario guadarlos en un archivo y en texto plano.
openssl x509 -req -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -days 730 -in allfait.csr -out allfait.crt 

#setear el usuario con el siguiente comando
kubectl config set-credentials allfait --client-certificate=allfait.crt --client-key=allfait.key

#Comando para agreagr un contexto con nuestro nuevo usuario
kubectl config set-context allfait-minikube --cluster=minikube --user=allfait --namespace=default

#Listar contextos
kubectl config get-contexts

#Cambiar de contexto
kubectl config use-context allfait-minikube

#Ejecutar este comando de prueba para verificar permisos
kubectl get pods

#Cambiar de contexto
kubectl config use-context minikube

#Aplicamos el rol y lo listamos
kubectl get roles

#Aplicamos el rolbinding y lo listamos
kubectl get rolebinding

#Cambiamos al contexto de allfait-minikube y ejecutamos los siguientes comandos para ver los permisos que tiene.
kubectl config use-context allfait-minikube
kubectl get pods
kubectl run nginx --image=nginx

#volvemos al namespace minikube
kubectl config use-context minikube

#ejecutamos los siguientes comandos
kubectl create ns pruebas
kubectl run nginx --image=nginx -n pruebas

#Ahora vemos el cambio con allfait-context
kubectl config use-context allfait-minikube
kubectl get pods -n pruebas


#Creamos cluster-role y cluster-role-binding para poder tener permisos sobre todos los namespaces del cluster
kubectl config use-context minikube
kubectl config use-context allfait-minikube
kubectl get pods -n pruebas

#SERVICE ACCOUNTS - QUE SON
kubectl config use-context minikube
kubectl get sa
kubectl get sa -n pruebas
kubectl create sa pruebas-serviceaccount
kubectl get sa


#Crear pod de kubectl y ejecutar comandos dentro de el
kubectl get pods

#validacion si usuarios, grupos o serviceaccounts tienen permisos
kubectl auth can-i create pods

kubectl auth can-i create pods --as="system:serviceaccount:default:pruebas-serviceaccount"





