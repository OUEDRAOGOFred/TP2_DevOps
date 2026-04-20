# TP2 DevOps : Déploiement automatisé, orchestration et sécurité Kubernetes

Ce dépôt contient l'infrastructure as code (IaC), la configuration de gestion (Ansible) et les manifestes (Kubernetes) pour le TP 2 de DevOps. L'objectif est de passer d'une simple image Docker à une infrastructure résiliente, automatisée et sécurisée.

## 📁 Contenu du dépôt
* **`main.tf`** (Terraform) : Simule le provisionnement et démontre le concept d'"État souhaité vs État réel".
* **`setup-env.yml`** (Ansible) : Playbook pour l'automatisation idempotente des prérequis et des déploiements.
* **`manifest.yaml`** (Kubernetes) : Deployment (Rolling updates, probes) et Service.
* **`rbac-secret.yaml`** (Kubernetes) : Implémentation de la sécurité et du moindre privilège (RBAC & Secrets).

---

## 🚀 Guide d'exécution (Pour l'environnement Linux)

*Salut ! Si tu exécutes ce projet pour générer les captures d'écran du TP, suis scrupuleusement les étapes ci-dessous.*

### Prérequis sur la machine Linux :
* Avoir un cluster Kubernetes local fonctionnel (ex: `minikube start`).
* Avoir `terraform` et `ansible` d'installés.

---

### Étape 1 : L'Infrastructure as Code (Terraform)
1. Ouvre le terminal dans le dossier cloné.
2. Exécute les commandes suivantes :
```bash
terraform init
terraform plan
terraform apply -auto-approve
```
📸 **CAPTURE D'ÉCRAN 1** : Prends une capture du terminal montrant la réussite de la commande avec le message `L'état souhaité a été appliqué...` en vert.

---

### Étape 2 : Automatisation et Déploiement (Ansible)
Le playbook va vérifier les paquets, installer ce qui manque de manière idempotente, et déployer les fichiers YAML sur Kubernetes.
1. Exécute la commande suivante (Ansible va demander le mot de passe `sudo` de la machine Linux pour vérifier les paquets `apt`) :
```bash
ansible-playbook setup-env.yml --ask-become-pass
```
📸 **CAPTURE D'ÉCRAN 2** : Prends une capture montrant le "PLAY RECAP" à la fin, avec les tâches en vert `ok` et orange `changed`, prouvant l'idempotence.

---

### Étape 3 : Tests de Résilience (Kubernetes) - LE PLUS IMPORTANT

Maintenant que tout est déployé, on va prouver que l'infrastructure est solide (ce que le prof veut voir).

#### Test A : Scaling (Mise à l'échelle)
```bash
# Vérifie qu'il y a 3 pods au départ
kubectl get pods

# Passe à 5 pods
kubectl scale deployment app-tp1-deployment --replicas=5

# Vérifie que les pods se créent
kubectl get pods
```
📸 **CAPTURE D'ÉCRAN 3** : Prends une capture montrant la commande de scaling et le résultat de `get pods` avec les 5 pods en `Running` ou `ContainerCreating`.

#### Test B : Rolling Update (Mise à jour sans coupure)
```bash
# Lance une mise à jour vers la v2
kubectl set image deployment/app-tp1-deployment web-app=mon-app-tp1:v2 --record

# Observe la mise à jour progressive
kubectl rollout status deployment/app-tp1-deployment
```
📸 **CAPTURE D'ÉCRAN 4** : Prends une capture des messages du type `Waiting for rollout to finish...` prouvant que la stratégie a bien fonctionné.

#### Test C : Rollback (Retour arrière par sécurité)
```bash
# Annule le déploiement précédent pour revenir à la v1
kubectl rollout undo deployment/app-tp1-deployment

# Observe le statut du retour arrière
kubectl rollout status deployment/app-tp1-deployment
```
📸 **CAPTURE D'ÉCRAN 5** : Prends une capture montrant que le `rollout undo` a été un succès (message de type `deployment successfully rolled out`).

---
🎉 **Fin du TP !** Récupère ces 5 captures d'écran et intègre-les dans ton compte rendu.