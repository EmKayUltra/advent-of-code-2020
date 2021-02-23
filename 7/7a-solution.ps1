[CmdletBinding()]
param()
$inputs = get-content "input-test.txt"

class Bag {
    [string]$Name
    [System.Collections.ArrayList]$Capacity

    Bag([string]$name, [BagQuantity[]]$capacity) {
        $this.Name = $name
        $this.Capacity = $capacity
    }
}

class GraphVertex {
    [Bag]$Source
    [Bag]$Target

    GraphVertex([Bag]$source, [Bag]$target) { 
        $this.Source = $source
        $this.Target = $target
    }
}

class GraphNode {
    [GraphVertex[]]$Vertices
    [Bag]$Bag

    Inputs() { $this.Vertices | ? { $null -ne $_.Target } }

    Outputs() { $this.Vertices | ? { $null -ne $_.Source } }

    IsRoot() { $null -eq $this.Inputs }

    IsLeaf() { $null -eq $this.Oututs }

    GraphNode([Bag]$bag, [GraphVertex[]]$vertices) {
        $this.Bag = $bag
        $this.Vertices = $vertices
    }
}

class BagGraph {
    [GraphNode[]]$Nodes


    Add([Bag]$bag) {
        # if ($existingBag = find $bag.Name) { 
        #     $existingBag.Capacity = $bag.Capacity
        #     return 
        # }

        $node = [GraphNode]::new()

        $node.bag = $bag

        $this.Bags | % {
            $thisBag = $_
            if ($thisBag.Capacity | ? { $_.Bag -eq $thisBag }) {
                $node.Vertices.Add([GraphVertex]::new($thisBag, $_.Bag))
            }
        }
        
        $bag.Capacity | % {
            if ($thisNode = FindNodeByBagName $_.Bag.Name) {
                $this.Vertices.Add([GraphVertex]::new($bag, $thisNode.Bag))
            }
        }

        $this.Nodes.Add($node)
    }

    FindNodeByBagName($name) { $this.Nodes | ? { $_.Bag.Name -eq $name } }

    # walkToTarget($name, $target) { $bag = find $name }
    
    WalkToRoot($name) { 
        $node = findByBagName $name
        
        $ancestorBags = $node.Bag.Inputs

        $ancestorBags | % {
            if (!$_.isRoot) {
                $ancestorBags += walkToRoot $_.Name
            }
        }

        $ancestorBags | select -property Name -unique
    }

    BagGraph() {
        $this.Nodes = [GraphNode[]]@()
    }
}

function parseInputs($inputs) {
    $inputs | % {
        $split = $_.split(" contain ")
        $bagName = $split[0].replace("bags", "bag")
        $childBags = ($split[1] -like "*no other*") ? $null : ($split[1].split(", ") | % { $_.replace("bags", "bag").replace(".", "")})
    
        $childBagQuantities = $childBags -eq $null ? $null : ($childBags | % { 
            $_ -match "([0-9]{1}) (.*)" | out-null

            @{ "quantity" = $matches[1]; "name" = $matches[2] } 
        })

        [psobject]@{
            "name" = $bagName
            "potential_contents" = $childBagQuantities
        }
    }
}

function canBagContainTarget($bag, $targetName) {
    write-host "Checking bag $($bag.name)"
    if ($br = getBagResult $bag.name) {
        write-host "already calculated ($br), skipping" -ForegroundColor Yellow

        return $br
    }
    
    if ($bag.potential_contents -eq $null) { setBagResult $bag.name $false; return $false }

    foreach($child in $bag.potential_contents)
    {
        write-host "|--- Checking $($child.name)"
        read-host
        if (($child.name -eq $targetName) -or (canBagContainTarget (getBag $child.name) $targetName)) {
            write-host "$($child.name) can hold target" -ForegroundColor green
            setBagResult $child.name $true
            return $true
        }
        else {
            setBagResult $child.name $false
        }
    }

    write-host "bag can not hold target" -ForegroundColor Red
    setBagResult $bag.name $false
    return $false
}

function getBag($name) { $bags | ? { $_.name -eq $name } }
function getBagResult([string]$name) { $bagResults.ContainsKey($name) ? $bagResults[$name] : $null }
function setBagResult([string]$name, [bool]$val) { 
    if (!$bagResults.ContainsKey($name)) { 
        write-host "saving result: $name, $val" -ForegroundColor DarkCyan
        $bagResults.Add($name, $val) 
    } 
}

$bags = parseInputs $inputs
$bagResults = @{}

$bags | ? {     
    canBagContainTarget $_ "shiny gold bag"
} | measure | select -ExpandProperty count

