.ONESHELL:
.PHONY: sync_fork

sync_and_update:
# Fetch upstream
	git remote get-url upstream >/dev/null 2>&1 || git remote add upstream https://github.com/numerique-gouv/sites-conformes
	git fetch upstream --tags
# Update main
	git checkout main
	git rebase upstream/main
	git push
# Check current production tag
	git checkout production
	current_tag=$$(git describe --tags --abbrev=0)
	latest_tag=$$(git tag --sort=-version:refname | head -n 1)
	if [ "$$current_tag" != "$$latest_tag" ]; then
		echo "Un tag plus récent existe : $$latest_tag (actuellement sur $$current_tag)"
		read -p "Mettre à jour [Y/n] ?" choice
		case "$$choice" in
			Y|y) git rebase "$$latest_tag"; git push ;;
			*)   echo "Annulé.";;
		esac
	else
		echo "Déjà sur le dernier tag $$current_tag, rien à faire"
	fi

