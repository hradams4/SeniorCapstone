# from django.http import HttpResponse NEEDED FOR STUB METHODS OF DETAIL/RESULTS/VOTE
# from django.template import loader NEEDED IF NOT USING RENDER()

from django.http import Http404
from django.shortcuts import get_object_or_404, render

from .models import Question

# USING RENDER() SHORTCUT
def index(request):
    latest_question_list = Question.objects.order_by('-pub_date')[:5]
    context = {'latest_question_list': latest_question_list}
    return render(request, 'polls/index.html', context)

# THIS IS WITHOUT THE RENDER() SHORTCUT
# def index(request):
#   latest_question_list = Question.objects.order_by('-pub_date')[:5]
#   template = loader.get_template('polls/index.html')
#   context = {
#       'latest_question_list': latest_question_list,
#   }
#   return HttpResponse(template.render(context, request))
#

def detail(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    return render(request, 'polls/detail.html', {'question': question})
    
def results(request, question_id):
    response = "You're looking at the results of question %s."
    return HttpResponse(response % question_id)

def vote(request, question_id):
    return HttpResponse("You're voting on question %s." % question_id)