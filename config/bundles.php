<?php

return [
    Symfony\Bundle\FrameworkBundle\FrameworkBundle::class                => [ 'all' => true ],
    Doctrine\Bundle\DoctrineCacheBundle\DoctrineCacheBundle::class       => [ 'all' => true ],
    Doctrine\Bundle\DoctrineBundle\DoctrineBundle::class                 => [ 'all' => true ],
    Doctrine\Bundle\MigrationsBundle\DoctrineMigrationsBundle::class     => [ 'all' => true ],
    Sensio\Bundle\FrameworkExtraBundle\SensioFrameworkExtraBundle::class => [ 'all' => true ],
    Symfony\Bundle\WebProfilerBundle\WebProfilerBundle::class            => [ 'dev' => true ],
    Symfony\Bundle\TwigBundle\TwigBundle::class                          => [ 'dev' => true ],
];