from django.http.response import HttpResponse
from .tasks import *


def index(request):
    res = add.delay(4, 5)
    return HttpResponse(res)
