set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(ifq) Queue/DropTail/PriQueue
set val(ll) LL 
set val(ant) Antenna/OmniAntenna
set val(ifqlen) 50
set val(nn) 3
set val(rp) DSDV


set ns [new Simulator] 



set nf [open mob.nam w]
$ns namtrace-all-wireless $nf 100 100  
set f [open mob.tr w]
$ns trace-all $f

proc finish {} {
    global ns nf
    $ns flush-trace 
    close $nf

    exec nam mob.nam & 
    exit 0
}

set topo [new Topography]

$topo load_flatgrid 100 100
create-god $val(nn)

$ns node-config -adhocRouting $val(rp) -llType $val(ll) -macType $val(mac) -ifqType $val(ifq) -ifqLen $val(ifqlen) -antType $val(ant) -propType $val(prop) -phyType $val(netif) -channelType $val(chan) \
	-topoInstance $topo -agentTrace ON -routeTrace OFF -macTrace OFF -movementTrace OFF

for {set i 0} {$i < 3} {incr i } {
	set n($i) [$ns node]
	$ns initial_node_pos $n($i) 10
	$n($i) set Y_ 50.0
	$n($i) set Z_ 0.0
}

$n(0) set X_ 25.0
$n(1) set X_ 50.0
$n(2) set X_ 65.0

set tcp [new Agent/TCP]
$ns attach-agent $n(0) $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n(2) $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 10.0 "$n(1) setdest 50.0 90.0 0.0"
$ns at 50.0 "$n(1) setdest 50.0 10.0 0.0"


$ns at 0.5 "$ftp start"
$ns at 1000 "$ftp stop"
$ns at 1000 "finish"
$ns run
