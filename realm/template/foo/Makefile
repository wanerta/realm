release=REALM_RELEASE
ns=REALM_NAMESPACE

ifneq ("$(wildcard /builder/helm.bash)","")
    helmCmd=/builder/helm.bash
else
    helmCmd=helm
endif

render-%: decrypt-%
	${helmCmd} template --debug ${release} -n ${ns} . --values $$(echo "$@" | sed 's/render-//').yaml

decrypt-%:
	./.decrypt.bash $$(echo "$@" | sed 's/decrypt-//')

upgrade-%: decrypt-%
	${helmCmd} upgrade --install ${release} -n ${ns} . --values $$(echo "$@" | sed 's/upgrade-//').yaml

clean:
	find . -name '.DS_Store' | xargs rm