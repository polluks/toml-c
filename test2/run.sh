if ! (which jq >& /dev/null); then 
    echo "ERROR: please install the 'jq' utility"
    exit 1
fi

#
#  POSITIVE tests
#
for i in toml-spec-tests/values/*.toml; do
    echo -n $i ' '
    res='[OK]'
    if (../toml_json $i >& $i.json.out); then 
        jq . $i.json.out > t.json
	if (diff $i.json t.json >& /dev/null); then 
	    mv t.json $i.json.failed
	    res='[FAILED]'
	fi
    fi
    echo $res
done


#
#  NEGATIVE tests
#
for i in toml-spec-tests/errors/*.toml; do 
    echo -n $i ' '
    if (../toml_json $i >& $i.json.out); then 
	echo '[FAILED]'
    else
	echo '[OK]'
    fi

done
