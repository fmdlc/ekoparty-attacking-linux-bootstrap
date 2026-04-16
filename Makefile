.PHONY: create remove verify secure help

INVENTORY=inventory.ini
PLAYBOOK=lab.yml
SECURE_PLAYBOOK=secure.yml

.DEFAULT_GOAL := help

help:
	@echo "Usage:"
	@echo "  make create   - Provision the lab environment"
	@echo "  make remove   - Cleanup the lab environment"
	@echo "  make verify   - Verify the lab environment"
	@echo "  make secure   - Provision the safe baseline environment"

create:
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) -e mode=create

remove:
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) -e mode=remove

secure:
	ansible-playbook -i $(INVENTORY) $(SECURE_PLAYBOOK)

verify:
	ansible -i $(INVENTORY) lab -b -m shell -a "systemctl is-active mariadb nginx vsftpd"
	ansible -i $(INVENTORY) lab -b -m shell -a "test -f /var/www/wordpress/wp-config.php && echo wp-config-ok"
	ansible -i $(INVENTORY) lab -b -m shell -a "test -f /var/www/wordpress/backup.tgz && echo backup-ok"
	ansible -i $(INVENTORY) lab -b -m shell -a "test -d /var/www/html && stat -c '%U:%G %a %n' /var/www/html"
	ansible -i $(INVENTORY) lab -b -m shell -a "id webmaster"
	ansible -i $(INVENTORY) lab -b -m shell -a "wp plugin list --path=/var/www/wordpress --status=active --allow-root"
