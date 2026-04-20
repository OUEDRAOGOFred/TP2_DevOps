# ==============================================================================
# CONCEPT CLÉ : État Souhaité vs État Réel (Declarative IaC)
# Terraform fonctionne sur un modèle déclaratif. L'ingénieur déclare l'"état 
# souhaité" (ce que l'on veut, par exemple "un cluster démarré avec tel fichier"). 
# Terraform compare ensuite cet état avec l'"état réel" de l'infrastructure 
# (via son fichier tfstate). S'il y a une différence, il calcule et applique 
# uniquement les changements nécessaires pour faire correspondre le réel au souhaité,
# sans ré-exécuter bêtement des commandes (c'est le cœur de l'idempotence).
# ==============================================================================

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }
}

provider "local" {}

# Simulation du provisionnement d'un environnement local
resource "local_file" "minikube_init_signal" {
  content  = "Environnement Kubernetes initialisé pour le TP DevOps. Prêt à recevoir les manifestes."
  filename = "${path.module}/.cluster_ready.log"
}

output "cluster_status" {
  value       = "L'état souhaité a été appliqué : l'environnement K8s est simulé comme actif."
  description = "Affiche la confirmation de l'initialisation de l'infra K8s."
}
