<?php
declare(strict_types=1);

namespace App\Controller;

use InvalidArgumentException;
use RuntimeException;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\Response;

class DefaultController
{
    /**
     * @Route("/")
     * @return Response
     * @throws InvalidArgumentException
     * @throws RuntimeException
     */
    public function indexAction(): Response
    {
        return new Response('<h1>It Works!</h1>');
    }
}
